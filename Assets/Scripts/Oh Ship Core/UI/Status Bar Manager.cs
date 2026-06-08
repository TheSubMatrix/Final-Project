using System;
using UnityEngine;
using UnityEngine.UI;

public class StatusBarManager : MonoBehaviour
{
    [SerializeField] StatusBar m_healthBar;
    [SerializeField] StatusBar m_thirstBar;
    public void UpdateHealthBar(float healthPercentage) => m_healthBar.UpdateFillPercentage(healthPercentage);
    public void UpdateThirstBar(float thirstPercentage) => m_thirstBar.UpdateFillPercentage(thirstPercentage);
    
    [Serializable]
    struct StatusBar
    {
        public Image Fill;
        public void UpdateFillPercentage(float fill)
        {
            Fill.fillAmount = Mathf.Clamp01(fill);
        }
    }
}
