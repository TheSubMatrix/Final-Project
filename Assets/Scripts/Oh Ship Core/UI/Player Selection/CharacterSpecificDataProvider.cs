using System.Collections.Generic;
using JetBrains.Annotations;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class CharacterSpecificDataProvider : PersistentService<ICharacterSpecificDataProvider>, ICharacterSpecificDataProvider
{
    private Dictionary<IPlayerController, SO_CharacterSpecificData> _characterSelectionDataSet = new();
  
    [Provide, UsedImplicitly] ICharacterSpecificDataProvider GetTransitioner() => this;

    public void SetCharacterModelSelection(IPlayerController player, SO_CharacterSpecificData characterSpecificData)
    {
        _characterSelectionDataSet[player] = characterSpecificData;
    }

    public SO_CharacterSpecificData GetCharacterSelectionData(IPlayerController player)
    {
        return  _characterSelectionDataSet[player];
    }

    public void ClearSelections()
    {
        _characterSelectionDataSet.Clear();
    }
}
