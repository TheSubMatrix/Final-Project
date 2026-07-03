using System;
using System.Collections.Generic;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class PlayerInteractionState : MonoBehaviour
{
    [SerializeField] private HashSet<InteractionTag> m_interactionTags =  new HashSet<InteractionTag>();
    [Inject] INotificationMessenger m_notificationMessenger;

    private void Start()
    { 
        FindAnyObjectByType<Injector>().Inject(this);
    }

    public void AddInteractionTag(InteractionTag interactionTag)
    {
        
        if(m_interactionTags.Contains(interactionTag)) return;
        m_interactionTags.Add(interactionTag);
        m_notificationMessenger.TryNotify($"added {interactionTag}");
    }

    public void RemoveInteractionTag(InteractionTag interactionTag)
    {
        
        if(!m_interactionTags.Contains(interactionTag)) return;
        m_interactionTags.Remove(interactionTag);
        m_notificationMessenger.TryNotify($"removed {interactionTag}");
    }
    
    public bool CheckInteractionTag(InteractionTag interactionTag)
    {
        return  m_interactionTags.Contains(interactionTag);
    }

    private void Update()
    {
        /*if (m_interactionTags.Count > 0)
            Debug.Log($"Active tags: {string.Join(", ", m_interactionTags)}");*/
    }
}
