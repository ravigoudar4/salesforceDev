public class callCmpController {
    public Boolean isCallCmp {get;set;}
    
    public callCmpController()
    {
        isCallCmp = false;
    }
    
    public void updateOnClick(){
        isCallCmp = true;
        System.debug('isCallcmp---->'+isCallCmp);
    }
}