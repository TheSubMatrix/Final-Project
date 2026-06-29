using System;
using MatrixUtils.Timers;
using UnityEngine;

public class DriftEvent : IDriftingEvent
{
    public event Action OnCancelled;
    public event Action OnWarningThresholdReached;
    public event Action OnFailureThresholdReached;
    public event Action OnFailure;
    readonly Action<float> m_updateFillAction;
    readonly Func<float, bool> m_evaluateStability;
    readonly float m_fillRate;
    readonly float m_warningThreshold;
    readonly float m_fillTarget;
    readonly float m_failureTime;
    bool m_eventPaused;
    bool m_warningActive;
    bool m_failureActive;
    Action m_onFailureCallback;
    CountdownTimer m_failureTimer;

    public DriftEvent(Action<float> updateFillAction, Func<float, bool> evaluateStability, float fillRate, float warningThreshold, float fillTarget, float failureTime)
    {
        m_updateFillAction = updateFillAction;
        m_evaluateStability = evaluateStability;
        m_fillRate = fillRate;
        m_warningThreshold = warningThreshold;
        m_fillTarget = fillTarget;
        m_failureTime = failureTime;
    }

    public void OnEventStart(float currentFill) { }

    bool m_hasLeftStableRange;

    public void OnEventUpdate(float currentFill)
    {
        if (m_eventPaused) return;
        float newFill = Mathf.MoveTowards(currentFill, m_fillTarget, m_fillRate * Time.deltaTime);
        m_updateFillAction(newFill);
    
        if (!m_hasLeftStableRange)
        {
            m_hasLeftStableRange = !m_evaluateStability(newFill);
            return;
        }
    
        if (!m_warningActive && Mathf.Abs(newFill - m_fillTarget) <= m_warningThreshold)
        {
            m_warningActive = true;
            OnWarningThresholdReached?.Invoke();
        }

        if (m_failureActive || !Mathf.Approximately(newFill, m_fillTarget)) return;
        m_failureActive = true;
        OnFailureThresholdReached?.Invoke();
        m_onFailureCallback = () => OnFailure?.Invoke();
        m_failureTimer = new(m_failureTime);
        m_failureTimer.OnTimerStop += m_onFailureCallback;
        m_failureTimer.Start();
    }

    public void OnEventPaused(float currentFill)
    {
        m_eventPaused = true;
        m_failureTimer?.Pause();
    }

    public void OnEventResumed(float currentFill)
    {
        if (m_evaluateStability(currentFill))
        {
            OnEventEnd(currentFill);
            return;
        }
        m_eventPaused = false;
        m_failureTimer?.Resume();
    }

    public void OnEventEnd(float currentFill)
    {
        if (m_failureTimer != null)
        {
            m_failureTimer.OnTimerStop -= m_onFailureCallback;
            m_failureTimer = null;
        }
        OnCancelled?.Invoke();
    }
}