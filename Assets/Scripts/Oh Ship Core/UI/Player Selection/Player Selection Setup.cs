using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerSelectionSetup : MonoBehaviour
{
    [Inject] IPlayerSelectionHandler m_playerSelectionHandler;
    [SerializeField] PlayerSelectionCard m_playerSelectionCardPrefab;
    [SerializeField] private Transform m_selectionMovementZoneLocation;
    public void SetupCardSelection(PlayerInput playerInput)
    {
        PlayerSelectionCard card = Instantiate(m_playerSelectionCardPrefab, m_selectionMovementZoneLocation);
        if(!playerInput.gameObject.TryGetComponent<IPlayerController>(out IPlayerController component)) return;
        component.ChangeControlledEntity(card);
    }
}
