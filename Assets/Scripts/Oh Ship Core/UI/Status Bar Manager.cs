using System;
using UnityEngine;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.Playables;
using UnityEngine.UI;

public class HungerAndThirstVisualManager : MonoBehaviour
{
    [SerializeField] StatusBar m_hungerBar;
    [SerializeField] StatusBar m_thirstBar;

    [SerializeField] private Image fadeImage;
    private Color imageAlpha;
    
    public void UpdateHunger(float hungerPercentage) => m_hungerBar.UpdateFillPercentage(hungerPercentage);
    public void UpdateThirst(float thirstPercentage) => m_thirstBar.UpdateFillPercentage(thirstPercentage);

    [Serializable]
    struct StatusBar
    {
        public Image Fill;
        public void UpdateFillPercentage(float fill)
        {
            Fill.fillAmount = fill;
        }
    }
    
    public void SlowDown(float hungerValue)
    {
        imageAlpha = fadeImage.color;
        imageAlpha.a = 1 - hungerValue;
        fadeImage.color = imageAlpha;
        
    }

    public void ResetFade()
    {
        imageAlpha = fadeImage.color;
        imageAlpha.a = 0f;
        fadeImage.color = imageAlpha;
    }
}
