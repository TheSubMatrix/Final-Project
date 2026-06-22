using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;
using UnityEngine.UI;

public class CharacterSelectorButton : Button
{
    [SerializeField] SO_CharacterSpecificData m_characterData;
    [SerializeField] public UnityEvent<int> OnCharacterSelectedSuccessfully = new();
    [SerializeField] public UnityEvent<int> OnCharacterSelectionFailed = new();
    [SerializeField] public UnityEvent<int> OnCharacterDeselected = new();
    [Inject] ICharacterSelectionDataHandler m_characterSelectionDataHandler;

    int m_ownerPlayerIndex = -1;
    bool IsLockedIn => m_ownerPlayerIndex != -1;

    public override void OnSubmit(BaseEventData eventData)
    {
        Debug.Log("Submit");
        if (!TryGetPlayerInput(eventData, out PlayerInput playerInput)) return;
        if (IsLockedIn)
        {
            if (playerInput.playerIndex != m_ownerPlayerIndex) return;
            m_characterSelectionDataHandler.ClearCharacterSelectionData(m_ownerPlayerIndex);
            m_ownerPlayerIndex = -1;
            OnCharacterDeselected.Invoke(playerInput.playerIndex);
            Debug.Log("Deselected");
            return;
        }
        if (m_characterSelectionDataHandler.TrySetCharacterSelectionData(playerInput.playerIndex, m_characterData))
        {
            m_ownerPlayerIndex = playerInput.playerIndex;
            OnCharacterSelectedSuccessfully.Invoke(playerInput.playerIndex);
            Debug.Log("Selected");
            base.OnSubmit(eventData);
        }
        else
        {
            OnCharacterSelectionFailed.Invoke(playerInput.playerIndex);
        }
    }

    public override void OnMove(AxisEventData eventData)
    {
        if (IsLockedIn && TryGetPlayerInput(eventData, out PlayerInput playerInput) && playerInput.playerIndex == m_ownerPlayerIndex) return;
        base.OnMove(eventData);
    }

    static bool TryGetPlayerInput(BaseEventData eventData, out PlayerInput playerInput)
    {
        if (eventData.currentInputModule is InputSystemUIInputModule { } inputModule && inputModule.transform.root.GetComponent<PlayerInput>() is { } input)
        {
            playerInput = input;
            return true;
        }
        playerInput = null;
        return false;
    }
}