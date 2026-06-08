using UnityEngine;

public interface IPromptDisplay
{
    void ShowPrompt(IPromptProvider prompt);
    void HidePrompt(IPromptProvider prompt);
}
