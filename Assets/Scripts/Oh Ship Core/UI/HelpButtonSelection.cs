using System;
using TMPro;
using UnityEngine. UI;
using UnityEngine;
using UnityEngine.EventSystems;
public class HelpButtonSelection : MonoBehaviour, ISelectHandler, IDeselectHandler
{
    [Header("Type what you want for the help text here")]
    [TextArea(3, 10)] [SerializeField] private string helpText;

    private GameObject m_helpPictureLabel;
    
    private Sprite _sprite;

    private void Start()
    {
        _sprite = GetComponent<Image>().sprite;
        m_helpPictureLabel = transform.GetChild(0).gameObject;
        m_helpPictureLabel.SetActive(false);
    }

    public void OnSelect(BaseEventData eventData)
    {
        if (m_helpPictureLabel == null) return;
        m_helpPictureLabel.SetActive(true);

    }

    public void OnDeselect(BaseEventData eventData)
    {
        if (m_helpPictureLabel == null) return;
        m_helpPictureLabel.SetActive(false);
    }

    public void OnClick()
    {
        HelpMenuManager.Instance.ShowHelp(helpText, _sprite);
    }
}

