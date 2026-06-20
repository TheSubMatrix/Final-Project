using UnityEngine;

public interface ICharacterSpecificDataProvider
{
    void SetCharacterModelSelection(IPlayerController player, SO_CharacterSpecificData characterSpecificData);
    SO_CharacterSpecificData GetCharacterSelectionData(IPlayerController player);
    public void ClearSelections();
}
