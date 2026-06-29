using System;

public interface IDriftingEvent
{
    public void OnEventStart(float currentFill);
    public void OnEventUpdate(float currentFill);
    public void OnEventPaused(float currentFill);
    public void OnEventResumed(float currentFill);
    public void OnEventEnd(float currentFill);
}