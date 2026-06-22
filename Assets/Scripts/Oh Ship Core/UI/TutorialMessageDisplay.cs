using System;
using TMPro;
using UnityEngine;
/// <summary>
/// Displays tutorial messages to the user based on input from data from <see cref="IMessageDisplay"/> 
/// </summary>
public class TutorialMessageDisplay : MonoBehaviour, IMessageDisplay
{
    [SerializeField] CanvasGroup m_messageCanvasGroup;
    [SerializeField] TMP_Text m_messageText;
    string m_message;
    /// <inheritdoc/>
    public void ShowMessage(string message)
    {
        throw new System.NotImplementedException();
    }
    /// <inheritdoc/>
    public void HideMessage()
    {
        OnMessageHidden?.Invoke(m_message);
    }
    /// <inheritdoc/>
    public event Action<string> OnMessageHidden;
}
