using System;
using System.Collections;
using MatrixUtils.Attributes;
using UnityEngine;

public class PlayerTransitionHider : MonoBehaviour, ITransitionHider
{
    [SerializeField, RequiredField] CanvasGroup m_fadeCanvasGroup;
    public bool IsFading { get; private set; }
    public bool FadeIn(float duration, Action onComplete = null)
    {
        if(IsFading) return false;
        StartCoroutine(FadeGroup(duration, onComplete, 1));
        return true;
    }

    public bool FadeOut(float duration, Action onComplete = null)
    {
        if(IsFading) return false;
        StartCoroutine(FadeGroup(duration, onComplete, 0));
        return true;
    }
    
    IEnumerator FadeGroup(float duration, Action onComplete, float desiredAlpha)
    {
        IsFading = true;
        if(desiredAlpha > 0) m_fadeCanvasGroup.blocksRaycasts = true;
        yield return m_fadeCanvasGroup.FadeToOpacity(desiredAlpha, duration);
        IsFading = false;
        m_fadeCanvasGroup.blocksRaycasts = m_fadeCanvasGroup.alpha > 0;
        onComplete?.Invoke();
    }
}
