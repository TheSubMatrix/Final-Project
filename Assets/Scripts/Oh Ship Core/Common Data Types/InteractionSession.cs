/// <summary>
/// Represents an ongoing interaction between an <see cref="IInteractor"/> and an <see cref="IInteractable"/>
/// </summary>
public class InteractionSession
{
    /// <summary>
    /// The <see cref="IInteractor"/> that is currently interacting with the <see cref="Target"/>
    /// </summary>
    public IInteractor CurrentInteractor { get; private set; }
    /// <summary>
    /// The <see cref="IInteractable"/> that is being interacted with.
    /// </summary>
    public IInteractable Target { get; private set; }
    /// <summary>
    /// Whether the interaction session is still active.
    /// </summary>
    public bool IsActive { get; private set; }
    /// <summary>
    /// Creates a new <see cref="InteractionSession"/>
    /// </summary>
    /// <param name="interactor">The <see cref="IInteractor"/> doing the interaction</param>
    /// <param name="target">The target <see cref="IInteractable"/> for the session</param>
    public InteractionSession(IInteractor interactor, IInteractable target)
    {
        CurrentInteractor = interactor;
        Target = target;
        IsActive = true;
    }
    /// <summary>
    /// Transfers the interaction session to a new <see cref="IInteractor"/>
    /// </summary>
    /// <param name="newInteractor">The <see cref="IInteractor"/> to transfer ownership to</param>
    public void TransferTo(IInteractor newInteractor)
    {
        CurrentInteractor = newInteractor;
    }
    /// <summary>
    /// Ends the <see cref="InteractionSession"/>
    /// </summary>
    public void End()
    {
        IsActive = false;
        CurrentInteractor = null;
        Target = null;
    }
}