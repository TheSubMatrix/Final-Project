using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerSelectionCard : MonoBehaviour, IPlayerControllable
{
    string m_requiredInputActionMap;
    IPlayerController m_activePlayerController;
    [Inject] IPlayerSelectionHandler m_playerSelectionHandler;
    Transform m_playerSelection;
    /// <inheritdoc/>
    public void OnControlRequested(IPlayerController player)
    {
        m_activePlayerController = player;
        if(!player.TryChangeInputActionMap(m_requiredInputActionMap, out InputActionMap actionMap)) return;
        InputAction navigateAction = actionMap.FindAction("Navigate");
        navigateAction.performed += OnNavigate;
        InputAction submitAction = actionMap.FindAction("Submit");
        submitAction.performed += OnSubmit;
    }
    /// <inheritdoc/>
    public void OnControlReleased()
    {
        if(!m_activePlayerController.TryGetCurrentInputActionMap(out InputActionMap actionMap)) return;
        InputAction navigateAction = actionMap.FindAction("Navigate");
        navigateAction.performed -= OnNavigate;
        InputAction submitAction = actionMap.FindAction("Submit");
        submitAction.performed -= OnSubmit;
        m_activePlayerController = null;
    }
    /// <inheritdoc/>
    public IPlayerController GetActivePlayerController() => m_activePlayerController;
    /// <inheritdoc/>
    public GameObject GetAssociatedGameObject() => gameObject;
    void OnNavigate(InputAction.CallbackContext context)
    {
        if(!m_playerSelectionHandler.TryGetNextAvailableSelection(m_playerSelection, context.ReadValue<Vector2>(), out Transform playerSelection)) return;
        m_playerSelection = playerSelection;
    }
    
    void OnSubmit(InputAction.CallbackContext context) => m_playerSelectionHandler.TrySelect(this, m_playerSelection);
}