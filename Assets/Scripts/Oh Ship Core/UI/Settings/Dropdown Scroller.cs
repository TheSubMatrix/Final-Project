using System.Collections;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class DropdownScroller : MonoBehaviour, ISelectHandler
{
    ScrollRect m_scrollRect;
    float m_scrollPosition;
    void Start()
    {
        m_scrollRect = GetComponentInParent<ScrollRect>(true);
        int childIndex = transform.GetSiblingIndex();
        int childCount = m_scrollRect.content.transform.childCount;
        childIndex = childIndex < ((float)childCount / 2) ? childIndex -1 : childIndex;
        m_scrollPosition = 1 - ((float)childIndex / childCount);
    }

    public void OnSelect(BaseEventData eventData)
    {
        StartCoroutine(WaitAFrameThanksUnity(eventData));
    }
    IEnumerator WaitAFrameThanksUnity(BaseEventData eventData)
    {
        yield return null;
        if(eventData is not AxisEventData) yield break;
        m_scrollRect.verticalScrollbar.value = m_scrollPosition;
    }
}
