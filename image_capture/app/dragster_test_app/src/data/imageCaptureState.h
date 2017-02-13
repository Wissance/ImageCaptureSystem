#ifndef SRC_DATA_IMAGECAPTURESTATE_H_
#define SRC_DATA_IMAGECAPTURESTATE_H_


struct ImageCaptureState
{
public:
    bool getState(){return _enabled;}
    void setState(bool state) {_enabled = state;}
private:
	bool _enabled;
};


#endif /* SRC_DATA_IMAGECAPTURESTATE_H_ */
