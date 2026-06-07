using System;

/// <summary>
/// Represents an object that can display a prompt to the user. Used for things like notifying the player that an object is interactable.
/// </summary>
public interface IWorldPromptDisplay
{
    void ShowPrompt(Action onPromptShown = null);
    void HidePrompt(Action onPromptHidden = null);
    void EnablePrompt();
    void DisablePrompt();
}
