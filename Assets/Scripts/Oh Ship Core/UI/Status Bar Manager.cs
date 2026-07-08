using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class HungerAndThirstVisualManager : MonoBehaviour
{
    [SerializeField] StatusBar m_hungerBar;
    [SerializeField] StatusBar m_thirstBar;
    [FormerlySerializedAs("m_hungerVolume")] [SerializeField] VolumeSettings m_playerStatusVolume;
    public void UpdateHunger(float hungerPercentage)
    {
        m_hungerBar.UpdateFillPercentage(hungerPercentage);
        m_playerStatusVolume.HandlePostEffects(Mathf.Min(hungerPercentage, m_thirstBar.Fill.fillAmount));
    }

    public void UpdateThirst(float thirstPercentage)
    {
        m_thirstBar.UpdateFillPercentage(thirstPercentage);
        m_playerStatusVolume.HandlePostEffects(Mathf.Min(thirstPercentage, m_hungerBar.Fill.fillAmount));
    }

    [Serializable]
    struct StatusBar
    {
        public Image Fill;
        public void UpdateFillPercentage(float fill) => Fill.fillAmount = fill;
    }
    
    [Serializable]
    struct VolumeSettings
    {
        public Volume Volume;
        public float FadePoint;
        public void HandlePostEffects(float percentage)
        {
            float fadeRange = 1f - FadePoint;
            float t = Mathf.Clamp01((FadePoint - percentage) / fadeRange);
            Volume.weight = t;
        }
    }
}
