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
    private INotificationMessenger m_messenger;

    
    [Inject, UsedImplicitly]
    void InjectMessenger(INotificationMessenger messenger)
    {
       m_messenger = messenger;
    }

    public void OnPlayerControllerConnect(IPlayerController playerController)
    {
        Debug.Log($"OnPlayerControllerConnect called, messenger null: {m_messenger == null}");
        if (!playerController.TryGetPlayerIndex(out int playerIndex)) return;
        Debug.Log($"Subscribing for player {playerIndex}");
    
        foreach (WarningIcon warningIcon in m_warningIcons)
        {
            Debug.Log($"Subscribing to: '{warningIcon.EnableMessage} player{playerIndex}'");

            m_messenger.TrySubscribe($"{warningIcon.EnableMessage} player{playerIndex}", () => StartCoroutine(warningIcon.EnableWarning()));
            m_messenger.TrySubscribe($"{warningIcon.EnableMessage} player{playerIndex}", () => StartCoroutine(warningIcon.FlashWarningLabel(true)));
            m_messenger.TrySubscribe($"{warningIcon.DisableMessage} player{playerIndex}", () => StartCoroutine(warningIcon.DisableWarning()));
            m_messenger.TrySubscribe($"{warningIcon.DisableMessage} player{playerIndex}", () => StartCoroutine(warningIcon.FlashWarningLabel(false)));
        }

        foreach (WorldWarningIcon worldIcon in m_worldWarningIcons)
        {
            m_messenger.TrySubscribe($"{worldIcon.EnableMessage} player{playerIndex}", () => worldIcon.Enable());
            m_messenger.TrySubscribe($"{worldIcon.DisableMessage} player{playerIndex}", () => worldIcon.Disable());
        }
    }}
    
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
            Debug.Log("Display");
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

