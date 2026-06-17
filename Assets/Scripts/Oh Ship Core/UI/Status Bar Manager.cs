using System;
using UnityEngine;
using UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.Playables;
using UnityEngine.UI;

public class StatusBarManager : MonoBehaviour
{
    [SerializeField] StatusBar m_hungerBar;
    [SerializeField] StatusBar m_thirstBar;

    [SerializeField] private Image fadeImage;
    private Color imageAlpha;
    InteractionSession m_currentInteractionSession;
    public bool isPassedOut = false;
    public bool wokeUp = false;

    public void UpdateHungerBar(float hungerPercentage)
    {
        m_hungerBar.UpdateFillPercentage(hungerPercentage);

        if (hungerPercentage <= 0f)
        {
            //UnityEngine.SceneManagement.SceneManager.LoadScene("GameOver");
            PassOut();
        }
        else if (hungerPercentage <= 0.3f && hungerPercentage > 0f)
        {
            Debug.Log("fades");
            SlowDown();
        }
    }
    public void UpdateThirstBar(float thirstPercentage) => m_thirstBar.UpdateFillPercentage(thirstPercentage);

    [Serializable]
    struct StatusBar
    {
        public Image Fill;
        public void UpdateFillPercentage(float fill)
        {
            Fill.fillAmount = fill;
            Debug.Log("fill:" + fill);

        }
    }

    public void PassOut()
    {
        isPassedOut = true;
    }

    public void SlowDown()
    {
        imageAlpha = fadeImage.color;
        imageAlpha.a += Time.deltaTime/30;
        fadeImage.color = imageAlpha;
    }

    public void WakeUp()
    {
        wokeUp = true;
        isPassedOut = false;
        imageAlpha.a = 0;
        fadeImage.color = imageAlpha;

    }

}
