using System;
using MatrixUtils.Timers;
using UnityEngine;
public class ShipHole : MonoBehaviour, IInteractable
{
    Action m_onRepairComplete;
    [SerializeField] float m_repairTime;
    CountdownTimer m_repairTimer;
    InteractionSession m_currentInteraction;

    public void Initialize(Action onRepairComplete)
    {
        m_onRepairComplete = onRepairComplete;
        m_repairTimer = new(m_repairTime);
    }
    /// <inheritdoc/>
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        if (m_currentInteraction != null) return null;
        InteractionSession session = new(interactor, this);
        m_currentInteraction = session;

        session.OnEnded += () =>
        {
            m_currentInteraction = null;
            if (m_repairTimer is null) return;
            m_repairTimer.Pause();
        };

        m_repairTimer.OnTimerStop += HandleRepairEnd;
        m_repairTimer.Start();

        return session;
    }

    void HandleRepairEnd()
    {
        if (m_repairTimer is null) return;
        if (m_repairTimer.IsFinished)
        {
            m_onRepairComplete?.Invoke();
            m_repairTimer = null;
            return;
        }
        m_repairTimer.Pause();
    }
}
