using MatrixUtils.DependencyInjection;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerSelectionCard : MonoBehaviour, IPlayerControllable
{
    [SerializeField] float m_moveSpeed = 8f;

    [SerializeField] string m_requiredInputActionMap = "UI";
    IPlayerController m_activePlayerController;
    IPlayerSelection m_currentSelection;
    [Inject] IPlayerSelectionHandler m_playerSelectionHandler;
    RectTransform m_rectTransform;
    Vector3 m_targetPosition;
    bool m_isMoving;

    void Start()
    {
        FindAnyObjectByType<Injector>().Inject(this);
        m_rectTransform = GetComponent<RectTransform>();
        m_currentSelection = m_playerSelectionHandler.GetDefaultSelectionZone();
        Debug.Log($"Default selection: {m_currentSelection}");
        Debug.Log($"Handler: {m_playerSelectionHandler}, Default: {m_playerSelectionHandler?.GetDefaultSelectionZone()}");
    }
    void Update()
    {
        if (!m_isMoving) return;
        m_rectTransform.anchoredPosition = Vector3.MoveTowards(m_rectTransform.anchoredPosition, m_targetPosition, m_moveSpeed * Time.deltaTime);
        if (!(Vector3.Distance(m_rectTransform.anchoredPosition3D, m_targetPosition) < 0.1f)) return;
        m_isMoving = false;
    }

    void MoveTo(IPlayerSelection selection)
    {
        m_targetPosition = selection.Transform.localPosition;
        m_isMoving = true;
    }
    /// <inheritdoc/>
    public void OnControlRequested(IPlayerController player)
    {
        m_activePlayerController = player;
        if (!player.TryChangeInputActionMap(m_requiredInputActionMap, out InputActionMap actionMap)) return;
        actionMap.FindAction("Navigate").performed += OnNavigate;
        actionMap.FindAction("Submit").performed += OnSubmit;
    }
    /// <inheritdoc/>
    public void OnControlReleased()
    {
        if (!m_activePlayerController.TryGetCurrentInputActionMap(out InputActionMap actionMap)) return;
        actionMap.FindAction("Navigate").performed -= OnNavigate;
        actionMap.FindAction("Submit").performed -= OnSubmit;
        m_playerSelectionHandler.TryCancelSelection(this, m_currentSelection);
        m_activePlayerController = null;
    }
    /// <inheritdoc/>
    public IPlayerController GetActivePlayerController() => m_activePlayerController;
    /// <inheritdoc/>
    public GameObject GetAssociatedGameObject() => gameObject;

    void OnNavigate(InputAction.CallbackContext context)
    {
        Debug.Log($"Current selection before navigate: {m_currentSelection}");
        if (context.ReadValue<Vector2>().magnitude < 0.5f) return;
        if (!m_playerSelectionHandler.TryGetNextAvailableSelection(this, m_currentSelection, context.ReadValue<Vector2>(), out IPlayerSelection next)) return;
        m_currentSelection = next;
        MoveTo(next);
        
        //Debug.Log("Navigating to " + next.Transform.position);
    }

    void OnSubmit(InputAction.CallbackContext context)
    {
        if (m_currentSelection == null) return;
        if (!m_currentSelection.IsSelectedBy(this)) m_playerSelectionHandler.TryConfirmSelection(this, m_currentSelection);
        else m_playerSelectionHandler.TryCancelSelection(this, m_currentSelection);
    }
}