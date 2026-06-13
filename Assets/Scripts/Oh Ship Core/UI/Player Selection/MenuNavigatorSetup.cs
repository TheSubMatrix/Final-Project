using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;

public class MenuNavigatorSetup : MonoBehaviour
{
    [Inject] IMenuHandler _mMenuHandler;
    [FormerlySerializedAs("m_playerSelectionCardPrefab")] [SerializeField] MenuNavigator mMenuNavigatorPrefab;
    [SerializeField] private Transform m_selectionMovementZoneLocation;
    public void SetupCardSelection(PlayerInput playerInput)
    {
        MenuNavigator card = Instantiate(mMenuNavigatorPrefab, m_selectionMovementZoneLocation);
        if(!playerInput.gameObject.TryGetComponent<IPlayerController>(out IPlayerController component)) return;
        component.ChangeControlledEntity(card);
    }
}
