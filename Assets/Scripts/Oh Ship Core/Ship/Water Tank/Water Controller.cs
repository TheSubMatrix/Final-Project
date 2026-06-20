using System;
using MatrixUtils.Attributes;
using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.SceneManagement;

/// <summary>
/// Controls the fill of the water tank using states that use the <see cref="IFillState"/> interface.
/// </summary>
public class WaterController : MonoBehaviour
{
    [Inject] INotificationMessenger m_notificationMessenger;
    [SerializeField] float m_criticalStateBuffer = 0.01f;
    [SerializeField] float m_maxFill = 1f;
    [SerializeField] float m_minFill = -1f;
    [SerializeField] float m_fillRate = 1f;
    [SerializeField] float m_currentFill;
    
    [SerializeField] float m_minHoldDuration = 120f;
    [SerializeField] float m_maxHoldDuration = 180f;
    [SerializeField, RequiredField] MeshRenderer m_waterFillMesh;
    static readonly int s_fillProperty = Shader.PropertyToID("_Fill");

    IFillState m_activeFillChange;
    NeutralFillState m_neutral;
    ChangeFillState m_increase;
    ChangeFillState m_decrease;
    /// <summary>
    /// Attempts to increase the fill of the water tank.
    /// </summary>
    public void IncreaseWaterFill() => m_activeFillChange.HandleIncrease();
    /// <summary>
    /// Attempts to decrease the fill of the water tank.
    /// </summary>
    public void DecreaseWaterFill() => m_activeFillChange.HandleDecrease();

    bool IsInCriticalState => m_currentFill <= m_minFill + + m_criticalStateBuffer || m_currentFill  >= m_maxFill - + m_criticalStateBuffer;
    bool m_hasStartedWarning;
    void Awake()
    {
        m_neutral = new(UpdateWaterFillChange, m_fillRate, m_minHoldDuration, m_maxHoldDuration);
        m_increase = new(UpdateWaterFillChange, m_maxFill, m_fillRate);
        m_decrease = new(UpdateWaterFillChange, m_minFill, m_fillRate);
        m_neutral.OnIncrease = m_increase;
        m_neutral.OnDecrease = m_decrease;
        m_increase.OnIncrease = m_increase;
        m_increase.OnDecrease = m_neutral;
        m_decrease.OnIncrease = m_neutral;
        m_decrease.OnDecrease = m_decrease; 
        UpdateWaterFillChange(m_neutral);
    }

    void UpdateWaterFillChange(IFillState fillChange)
    {
        if (m_activeFillChange != null)
        {
            m_activeFillChange.OnFillChange -= UpdateCurrentFill;
            m_activeFillChange.OnEventEnded();
        }
        m_activeFillChange = fillChange;
        m_activeFillChange.OnFillChange += UpdateCurrentFill;
        m_activeFillChange.OnEventStarted(m_currentFill);
    }

    void UpdateCurrentFill(float newValue)
    {
        m_currentFill = Mathf.Clamp(newValue, m_minFill, m_maxFill);
        m_waterFillMesh.material.SetFloat(s_fillProperty, m_currentFill);
    }

    void Update()
    {
        if (IsInCriticalState && !m_hasStartedWarning)
        {
            m_notificationMessenger.TryNotify("enable steam");
            m_hasStartedWarning = true;
        }
        if (IsInCriticalState || !m_hasStartedWarning) return;
        m_notificationMessenger.TryNotify("disable steam");
        m_hasStartedWarning = false;
    }
}