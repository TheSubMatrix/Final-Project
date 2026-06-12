using MatrixUtils.Attributes;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;
using UnityEngine.UI;

[RequireComponent(typeof(Selectable), typeof(Outline))]
public class ColoredSelectionOutline : MonoBehaviour, ISelectHandler, IDeselectHandler
{
    [SerializeField, RequiredField] PlayerColors m_playerColors;
    Outline m_outline;
    void Start()
    {
        m_outline = GetComponent<Outline>();
        m_outline.enabled = false;
    }
    public void OnSelect(BaseEventData eventData)
    {
        if (eventData.currentInputModule is not InputSystemUIInputModule module || !module.transform.root.TryGetComponent(out PlayerInput playerInput)) return;
        m_outline.enabled = true;
        m_outline.effectColor = m_playerColors.ColorMap[playerInput.playerIndex];
    }

    public void OnDeselect(BaseEventData eventData)
    {
        m_outline.enabled = false;
    }
}
