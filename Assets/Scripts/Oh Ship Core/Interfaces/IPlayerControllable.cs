using System.Diagnostics.Contracts;

/// <summary>
/// An interface for objects that can be controlled by a player. Handles what happens when a player requests control or releases it.
/// </summary>
public interface IPlayerControllable
{
    /// <summary>
    /// Called when a player requests control of this object.
    /// </summary>
    /// <param name="player">The <see cref="IPlayerController"/> requesting control of this object</param>
    void OnControlRequested(IPlayerController player);
    /// <summary>
    /// Called when a player releases control of this object.
    /// </summary>
    void OnControlReleased();

    /// <returns>The <see cref="IPlayerController"/> currently controlling this object</returns>
    [Pure] IPlayerController GetActivePlayerController();
}
