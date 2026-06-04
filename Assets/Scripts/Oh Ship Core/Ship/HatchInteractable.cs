using UnityEngine;

public class HatchInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] Transform m_outPosition;
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        interactor.GetAssociatedGameObject().transform.root.GetComponentInChildren<Rigidbody>().MovePosition(m_outPosition.position);
        return null;
    }
}
