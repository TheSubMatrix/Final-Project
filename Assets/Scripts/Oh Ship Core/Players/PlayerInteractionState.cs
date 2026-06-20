using System.Collections.Generic;
using UnityEngine;

public class PlayerInteractionState : MonoBehaviour
{
    [SerializeField] private HashSet<InteractionTag> m_interactionTags =  new HashSet<InteractionTag>();
    public void AddInteractionTag(InteractionTag interactionTag)
    {
        
        if(m_interactionTags.Contains(interactionTag)) return;
        m_interactionTags.Add(interactionTag);
    }

    public void RemoveInteractionTag(InteractionTag interactionTag)
    {
        
        if(!m_interactionTags.Contains(interactionTag)) return;
        m_interactionTags.Remove(interactionTag);
    }
    
    public bool CheckInteractionTag(InteractionTag interactionTag)
    {
        return  m_interactionTags.Contains(interactionTag);
    }
}
