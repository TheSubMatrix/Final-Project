using System.Collections.Generic;
using JetBrains.Annotations;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class CharacterSelectionDataHandler : PersistentService<ICharacterSelectionDataHandler>, ICharacterSelectionDataHandler
{
    readonly Dictionary<int, SO_CharacterSpecificData> m_characterSelectionDataSet = new();
    readonly HashSet<SO_CharacterSpecificData> m_selectedCharacters = new();
    [Provide, UsedImplicitly] ICharacterSelectionDataHandler GetTransitioner() => this;
    [Inject] ISceneTransitioner m_sceneTransitioner;
    public bool TrySetCharacterSelectionData(int playerIndex, SO_CharacterSpecificData characterSpecificData)
    {
        if(m_selectedCharacters.Contains(characterSpecificData)) return false;
        m_characterSelectionDataSet[playerIndex] = characterSpecificData;
        Debug.Log("Selected!");
        return m_selectedCharacters.Add(characterSpecificData);
    }
    public bool HasSelection(int playerIndex) => m_characterSelectionDataSet.ContainsKey(playerIndex);
    public bool TryGetCharacterSelectionData(int playerIndex, out SO_CharacterSpecificData characterSpecificData) => m_characterSelectionDataSet.TryGetValue(playerIndex, out characterSpecificData);
    public bool ClearCharacterSelectionData(int playerIndex) => m_characterSelectionDataSet.Remove(playerIndex, out SO_CharacterSpecificData data) && m_selectedCharacters.Remove(data);
    public SO_CharacterSpecificData GetCharacterSelectionData(int player) => m_characterSelectionDataSet[player];

    public void ClearSelections()
    {
        m_characterSelectionDataSet.Clear();
        m_selectedCharacters.Clear();
    }
}
