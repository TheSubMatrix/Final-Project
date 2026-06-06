using UnityEngine;
/// <summary>
/// Interacting with this object will move the <see cref="IInteractor"/> to the position specified in the inspector
/// </summary>
public class HatchInteractable : MonoBehaviour, IInteractable
{
    [SerializeField] Transform m_outPosition;
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        interactor.GetAssociatedGameObject().transform.root.GetComponentInChildren<Rigidbody>().MovePosition(m_outPosition.position);
        return null;
    }
}
