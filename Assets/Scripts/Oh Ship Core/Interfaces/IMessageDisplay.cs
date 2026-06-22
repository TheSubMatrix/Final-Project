using System;

/// <summary>
/// Represents a system to display messages to the user
/// </summary>
public interface IMessageDisplay
{
    /// <summary>
    /// Shows a message to the user
    /// </summary>
    /// <param name="message">The message to show</param>
    void ShowMessage(string message);
    /// <summary>
    /// Hides the current message if there is one
    /// </summary>
    void HideMessage();
    /// <summary>
    /// Event that is raised when a message is hidden
    /// </summary>
    event Action<string> OnMessageHidden;
}
