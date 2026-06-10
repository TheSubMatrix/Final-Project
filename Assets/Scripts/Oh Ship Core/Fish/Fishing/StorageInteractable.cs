using UnityEngine;

public class StorageInteractable : MonoBehaviour, IInteractable
{

    private IPlayerControllable _playerControllable;
    private Transform _holdingObjectTransform;
    InteractionSession m_currentInteractionSession;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        GameObject player = _playerControllable.GetAssociatedGameObject();

        _holdingObjectTransform = player.GetComponentInChildren<HeldObjectLocation>().transform;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public InteractionSession BeginInteraction(IInteractor interactor)
    {

        if (interactor.IsInteracting() || m_currentInteractionSession is { IsActive: true }) return null;

        if (interactor.IsHoldingObject())
        {
            Debug.Log("Holding Fish");
            m_currentInteractionSession = new InteractionSession(interactor, this);
            m_currentInteractionSession.End();
            return m_currentInteractionSession;
        }

        return m_currentInteractionSession;
    }
}
