using MatrixUtils.DependencyInjection;
using UnityEngine;

public class FuelWarning : MonoBehaviour
{
    private bool m_activeAlert = false;
    [Inject] INotificationMessenger m_notificationMessenger;
    
    public void NotifyLowFuelSystem(bool fuelIsLow)
    {
        if (fuelIsLow)
        {
            if (m_activeAlert) return;
            m_notificationMessenger.TryNotify("enable coal");
            Debug.Log("Low Fuel System");
            Debug.Log(m_notificationMessenger);
            m_activeAlert = true;
        }
        else
        {
            if (!m_activeAlert) return;
            m_notificationMessenger.TryNotify("disable coal");
            m_activeAlert = false;
        }
        
    }
}
