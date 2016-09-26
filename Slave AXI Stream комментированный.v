
`timescale 1 ns / 1 ps

	module slave_ip_v1_0_S00_AXIS #
	(
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32
	)
	(
		input wire  S_AXIS_ACLK,
		input wire  S_AXIS_ARESETN,
    
    // TREADY (transfer ready), исходящий сигнал сообщает мастеру
    // что мы (Slave) готовы принять данные в текущем цикле
		output wire  S_AXIS_TREADY,
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
    
    // TLAST(transfer last), сигнал сообщает что весь пакет потока данных был передан
		input wire  S_AXIS_TLAST,
    
    // TVALID(transfer valid), сигнал говорит нам о том что
    // передача данных от мастера корректна
		input wire  S_AXIS_TVALID
	);

  // На всякий случай, функция возвращает Ceiling Of Log base 2
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

  // Локальные константы (параметры)
	localparam NUMBER_OF_INPUT_WORDS  = 8; // Количество входящих данных, в данном случае в байтах
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);

  // Константы (параметры)
	parameter [1:0] IDLE = 1'b0, WRITE_FIFO  = 1'b1;
  
	wire axis_tready;
	reg mst_exec_state; // Переменная хранящая текущее состояние машины состояний 
	genvar byte_index;  // Специальная переменная, используется в Loop generate конструкции 
	wire fifo_wren; // Флаг готовности FIFO к записи
	reg fifo_full_flag; // Флаг сообщающий о том что FIFO заполнен (по всей видимости в шаблоне не используется)
	reg [bit_num-1:0] write_pointer; // Индекс в память stream_data_fifo (индекс текущего элемента)
	reg writes_done; // Флаг сообщающий что запись FIFO завершена

	assign S_AXIS_TREADY	= axis_tready;

  // Когда сигнал S_AXIS_ACLK переходит из 0 в 1 (positive edge)
  // выполняем этот блок.
	always @(posedge S_AXIS_ACLK) 
	begin
    // Обращаем внимание на постфикс N (negative logic),
    // то есть reset происходит когда S_AXIS_ARESETN == 0
	  if (!S_AXIS_ARESETN)
	    begin
        // Задаем IDLE в качестве текущего состояния машины состояний
	      mst_exec_state <= IDLE;
	    end  
	  else
	    case (mst_exec_state)
	      IDLE: 
	          if (S_AXIS_TVALID)
	            begin
                // Задаем WRITE_FIFO в качестве текущего состояния машины состояний
	              mst_exec_state <= WRITE_FIFO;
	            end
	          else
	            begin
                // Задаем IDLE в качестве текущего состояния машины состояний
	              mst_exec_state <= IDLE;
	            end
	      WRITE_FIFO:
          // Выполняем этот блок если все входящие байты были приняты (записаны)
	        if (writes_done)
	          begin
              // Задаем IDLE в качестве текущего состояния машины состояний
	            mst_exec_state <= IDLE;
	          end
          // Выполняем этот блок если не все 8 байтов приняты (записаны),
          // то есть наша машина состояний находится в состоянии WRITE_FIFO пока не будут приняты все данные
	        else
	          begin
              // Задаем WRITE_FIFO в качестве текущего состояния машины состояний
	            mst_exec_state <= WRITE_FIFO;
	          end

	    endcase
	end

  // Непрерывное присваивание (Continuous Assignment). Если машина состояний в WRITE_FIFO и у нас есть место для данных, сигналим что мы готовы.
	assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_INPUT_WORDS-1));

  // Когда сигнал S_AXIS_ACLK переходит из 0 в 1 (positive edge)
  // выполняем этот блок.
	always@(posedge S_AXIS_ACLK)
	begin
    // Обращаем внимание на постфикс N (negative logic),
    // то есть reset происходит когда S_AXIS_ARESETN == 0
	  if(!S_AXIS_ARESETN)
	    begin
        // Присваиваем переменной write_pointer значение 0
	      write_pointer <= 0;
        // Присваиваем переменной writes_done значение 0
	      writes_done <= 1'b0;
	    end  
	  else
	    if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)
	      begin
          // Выполняем блок если мы готовы к записи
	        if (fifo_wren)
	          begin
              // Инкрементируем переменную write_pointer для записи следующего байта
	            write_pointer <= write_pointer + 1;
              // Присваиваем переменной writes_done значение 0
	            writes_done <= 1'b0;
	          end
	          if ((write_pointer == NUMBER_OF_INPUT_WORDS-1)|| S_AXIS_TLAST)
	            begin
                // Присваиваем переменной writes_done значение 1
	              writes_done <= 1'b1;
	            end
	      end  
	end

  // Внимание! Непрерывное присваивание!
  // Когда этот wire 1 это значит что передача корректна(S_AXIS_TVALID)
  // и мы готовы принять данные (S_AXIS_TREADY)
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

  // Loop generate конструкция, позволяет нам "развернуть" петлю.
	generate
    // Петля из 4 итераций (Итераций 4 поскольку Data Width на интерфейсе 32 бита, то есть 4 байта)
	  for(byte_index=0; byte_index<= (C_S_AXIS_TDATA_WIDTH/8-1); byte_index=byte_index+1)
	  begin:FIFO_GEN
      // Memory размером 8 байт (little-endian, то есть LSB o). Если кто-то забыл, я потом об этом напишу.
	    reg  [(C_S_AXIS_TDATA_WIDTH/4)-1:0] stream_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];

      // Когда сигнал S_AXIS_ACLK переходит из 0 в 1 (positive edge)
      // выполняем этот блок.
	    always @( posedge S_AXIS_ACLK )
	    begin
        // Выполняем блок если FIFO готов к записи
	      if (fifo_wren)// && S_AXIS_TSTRB[byte_index])
	        begin
            // Внимание! write_pointer не является константой,
            // формально он - переменная, соответственно, то что находится в скобках
            // является Index Expression (Индексное Выражение), а это значит что
            // значение индекса также должно быть определено наряду с результатом
            // выражения стоящего справа от оператора неблокирующего присваивания
            // условно говоря в то же самое время. Иными словами, перед присваиванием
            // write_pointer будет инкрементирован в другом always@ блоке выполняющимся параллельно.
	          stream_data_fifo[write_pointer] <= S_AXIS_TDATA[(byte_index*8+7) -: 8];
	        end  
	    end  
	  end		
	endgenerate

	endmodule
