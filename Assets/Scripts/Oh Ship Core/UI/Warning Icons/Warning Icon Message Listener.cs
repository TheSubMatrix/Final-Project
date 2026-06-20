using System;
using System.Collections;
using JetBrains.Annotations;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class WarningIconMessageListener : MonoBehaviour
{
    [SerializeField] WarningIcon[] m_warningIcons;
    [Inject, UsedImplicitly]
    void InjectMessenger(INotificationMessenger messenger)
    {
        foreach (WarningIcon warningIcon in m_warningIcons)
        {
            messenger.TrySubscribe(warningIcon.EnableMessage, () => StartCoroutine(warningIcon.EnableWarning()));
            messenger.TrySubscribe(warningIcon.DisableMessage, () => StartCoroutine(warningIcon.DisableWarning()));
        }
    }
    [Serializable]
    struct WarningIcon
    {
        public CanvasGroup CanvasGroup;
        public string EnableMessage;
        public string DisableMessage;
        public IEnumerator EnableWarning()
        {
            yield return CanvasGroup.FadeToOpacity(1, 0.5f);
        }
        public IEnumerator DisableWarning()
        {
            yield return CanvasGroup.FadeToOpacity(0, 0.5f);
        }
    }
}
