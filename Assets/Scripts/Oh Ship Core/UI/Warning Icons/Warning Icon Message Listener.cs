using System;
using System.Collections;
using JetBrains.Annotations;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class WarningIconMessageListener : MonoBehaviour
{
    [SerializeField] WarningIcon[] m_warningIcons;
    [SerializeField] WorldWarningIcon[] m_worldWarningIcons;
    [Inject, UsedImplicitly]
    void InjectMessenger(INotificationMessenger messenger)
    {
        foreach (WarningIcon warningIcon in m_warningIcons)
        {
            messenger.TrySubscribe(warningIcon.EnableMessage, () => StartCoroutine(warningIcon.EnableWarning()));
            messenger.TrySubscribe(warningIcon.DisableMessage, () => StartCoroutine(warningIcon.DisableWarning()));
        }

        foreach (WorldWarningIcon worldIcon in m_worldWarningIcons)
        {
            messenger.TrySubscribe(worldIcon.EnableMessage, () => worldIcon.Enable());
            messenger.TrySubscribe(worldIcon.DisableMessage, () => worldIcon.Disable());
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

    [Serializable]
    struct WorldWarningIcon
    {
        public string GameObjectTag;
        public string EnableMessage;
        public string DisableMessage;

        public void Enable()
        {
            GameObject obj =  GameObject.FindWithTag(GameObjectTag);
            
            if (obj != null)
            {
                obj.transform.GetChild(0).gameObject.SetActive(true);
            }
        }

        public void Disable()
        {
            GameObject obj =  GameObject.FindWithTag(GameObjectTag);
            if (obj != null)
            {
                obj.transform.GetChild(0).gameObject.SetActive(false);
            }
        }
    }
}
