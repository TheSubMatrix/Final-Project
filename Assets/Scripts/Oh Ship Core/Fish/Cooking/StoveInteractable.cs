using UnityEngine;
using UnityEngine.InputSystem;

public class StoveInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    InteractionSession m_currentInteractionSession;
    [SerializeField] private GameObject fishToCook;
    private readonly string _widgetForPrompt = "interact";
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    // Start is called once before the first execution of Update after the MonoBehaviour is created

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        _playerController = _playerControllable.GetActivePlayerController();
        if (interactor.IsInteracting() || m_currentInteractionSession is { IsActive: true }) return null;
       
        if(!interactor.IsHoldingObject()) return m_currentInteractionSession;
        
        DestroyFishInHand();
        
        fishToCook.SetActive(true);
        
        return m_currentInteractionSession;
    }

    public PromptData GetPromptData()
    {
        return new PromptData { AssociatedWidget = _widgetForPrompt };
    }

    public Vector3 GetWidgetWorldPosition()
    {
       return transform.position;
    }

    private void DestroyFishInHand()
    {
        GameObject player = _playerControllable.GetAssociatedGameObject();
        HeldObjectLocation heldObjectLocation = player.GetComponentInChildren<HeldObjectLocation>();
        heldObjectLocation.DestroyObjectsInHand();
    }
}
