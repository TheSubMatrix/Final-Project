using System;
using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.Events;

public class FuelWarning : MonoBehaviour
{
    private bool m_activeAlert = false;
    [Inject] INotificationMessenger m_notificationMessenger;
    
    private float m_fuelLevel;
    [SerializeField] private ProcedurallyAnimatedElement m_fuelGauge;
    [SerializeField] private ProcedurallyAnimatedElement m_waterGauge;
    
    

    private void Start()
    {
        FindAnyObjectByType<Injector>().Inject(this);
    }

    public void NotifyLowFuelSystem(bool fuelIsLow)
    {
        if (fuelIsLow)
        {
            if (m_activeAlert) return;
            m_notificationMessenger.TryNotify("enable coal");
            m_activeAlert = true;
        }
        else
        {
            if (!m_activeAlert) return;
            m_notificationMessenger.TryNotify("disable coal");
            m_activeAlert = false;
        }
        
    }

    public void AdjustFuelGauge(float value)
    {
        m_fuelGauge.Transform.localRotation = Quaternion.Euler(0,m_fuelGauge.Transform.localEulerAngles.y,m_fuelGauge.GetNextAngle(value, m_fuelGauge.Transform.localRotation.eulerAngles.z));
    }
    
    public void AdjustWaterGauge(float value)
    {
        
        m_waterGauge.Transform.localRotation = Quaternion.Euler(0,m_waterGauge.Transform.localEulerAngles.y,m_waterGauge.GetNextAngle(value, m_waterGauge.Transform.localRotation.eulerAngles.z));

    }

    private void Update()
    {
      
        
    }

    [Serializable]
    class ProcedurallyAnimatedElement
    {
        public Transform Transform;
        public float MinAngle;
        public float MaxAngle;
        float m_velocity;

        public float GetNextAngle(float normalizedDesiredAngle, float currentAngle)
        {
            float desiredWheelAngle = Mathf.Lerp(MinAngle, MaxAngle, normalizedDesiredAngle);
            return Mathf.SmoothDampAngle(currentAngle, desiredWheelAngle, ref m_velocity, 0.1f);
        }
    }
}
