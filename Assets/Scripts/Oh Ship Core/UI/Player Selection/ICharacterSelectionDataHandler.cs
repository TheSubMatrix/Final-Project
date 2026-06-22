using UnityEngine;

public interface ICharacterSelectionDataHandler
{
    bool TrySetCharacterSelectionData(int playerIndex, SO_CharacterSpecificData characterSpecificData);
    public bool ClearCharacterSelectionData(int playerIndex);
    bool HasSelection(int playerIndex);
    bool TryGetCharacterSelectionData(int playerIndex, out SO_CharacterSpecificData characterSpecificData);
    public void ClearSelections();
}
