using System;
using MatrixUtils.Timers;
using UnityEngine;
/// <summary>
/// A fill state where the tank is filling or draining and is moving towards the target fill position
/// </summary>
public class ChangeFillState : IFillState
{
    public event Action<float> OnFillChange;
    public event Action OnWarningTriggered = delegate {};
    public event Action OnFailureTriggered = delegate {};
    public IFillState OnIncrease;
    public IFillState OnDecrease;
    
    readonly Action<IFillState> m_requestTransitionAction;
    readonly float m_targetFill;
    readonly float m_fillRate;
    readonly float m_warningThreshold;
    readonly float m_failureTime;
    
    CountdownTimer m_changeFillStateTimer;
    CountdownTimer m_failureTimer;
    float m_startingFill;
    bool m_hasTriggeredWarning;
    
    public ChangeFillState(Action<IFillState> requestTransitionAction, float targetFill, float fillRate, float warningThreshold, float failureTime)
    {
        m_requestTransitionAction = requestTransitionAction;
        m_targetFill = targetFill;
        m_fillRate = fillRate;
        m_warningThreshold = warningThreshold;
        m_failureTime = failureTime;
    }
    /// <inheritdoc/>
    public void OnEventStarted(float startingFill)
    {
        m_startingFill = startingFill;
        float duration = Mathf.Abs(startingFill - m_targetFill) / m_fillRate;
        if (duration <= 0f)
        {
            m_requestTransitionAction(OnIncrease);
            return;
        }
        m_changeFillStateTimer = new(duration);
        m_changeFillStateTimer.OnTimerTick += HandleFillChange;
        m_changeFillStateTimer.OnTimerStop += FillStateReached;
        m_changeFillStateTimer.Start();
    }
    /// <inheritdoc/>
    public void OnEventEnded()
    {
        m_hasTriggeredWarning = false;
        if (m_failureTimer != null)
        {
            m_failureTimer.OnTimerStop -= OnFailure;
            m_failureTimer.Stop();
        }
        if(m_changeFillStateTimer == null) return;
        m_changeFillStateTimer.OnTimerStop -= FillStateReached;
        m_changeFillStateTimer.Stop();
    }

    /// <inheritdoc/>
    public void HandleIncrease() => m_requestTransitionAction(OnIncrease);
    /// <inheritdoc/>
    public void HandleDecrease() => m_requestTransitionAction(OnDecrease);
    
    void HandleFillChange()
    {
        float newFill = Mathf.Lerp(m_startingFill, m_targetFill, 1-m_changeFillStateTimer.Progress);
        if (Mathf.Abs(newFill - m_targetFill) < m_warningThreshold && !m_hasTriggeredWarning)
        {
            OnWarningTriggered?.Invoke();
            m_hasTriggeredWarning = true;
        } 
        OnFillChange?.Invoke(newFill);
    }

    void FillStateReached()
    {
        OnFillChange?.Invoke(m_targetFill);
        m_failureTimer = new(m_failureTime);
        m_failureTimer.OnTimerStop += OnFailure;
        m_failureTimer.Start();
    }

    void OnFailure()
    {
        OnFailureTriggered?.Invoke();
        Debug.Log("Failure triggered");
    }
}