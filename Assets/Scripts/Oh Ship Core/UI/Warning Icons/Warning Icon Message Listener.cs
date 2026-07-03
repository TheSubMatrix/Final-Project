using System;
using System.Collections;
using JetBrains.Annotations;
using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.UI;

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
            messenger.TrySubscribe(warningIcon.EnableMessage, () => StartCoroutine(warningIcon.FlashWarningLabel(true)));
            messenger.TrySubscribe(warningIcon.DisableMessage, () => StartCoroutine(warningIcon.DisableWarning()));
            messenger.TrySubscribe(warningIcon.DisableMessage, () => StartCoroutine(warningIcon.FlashWarningLabel(false)));

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
        public Sprite[] sprites;
        public Image image;
        public IEnumerator EnableWarning()
        {
            yield return CanvasGroup.FadeToOpacity(1, 0.5f);
            
        }
        public IEnumerator DisableWarning()
        {
            yield return CanvasGroup.FadeToOpacity(0, 0.5f);
        }

        public IEnumerator FlashWarningLabel(bool enable)
        {
            if (!enable || sprites.Length < 2)
            {
                image.sprite = sprites[0];
                yield break;
            }

            float flashDuration = 2f;
            float flashInterval = 0.5f;
            float elapsed  = 0f;
            bool toggle = false;
            while (elapsed < flashDuration)
            {
                image.sprite = sprites[toggle ? 1 : 0];
                toggle = !toggle;
                yield return new WaitForSeconds(flashInterval);
                elapsed += flashInterval;
            }

            image.sprite = sprites[0];
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
