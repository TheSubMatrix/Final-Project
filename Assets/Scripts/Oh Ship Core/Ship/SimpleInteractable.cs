using UnityEngine;

public class SimpleInteractable : MonoBehaviour, IInteractable
{
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        Debug.Log("Simple Interactable Interacted");
        return new(interactor, this);
    }

}
