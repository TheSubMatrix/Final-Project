using System.Collections.Generic;
/// <summary>
/// A container for stats that can have a <see cref="StatModifier"/> applied to them.
/// </summary>
public class StatBlock
{
    /// <summary>
    /// The <see cref="StatBroker"/> that manages the application of <see cref="StatModifier"/>s to this <see cref="StatBlock"/>.
    /// </summary>
    public StatBroker Broker { get; } = new();
    readonly Dictionary<StatData, float> m_stats = new();
    /// <summary>
    /// Registers a stat with the <see cref="StatBlock"/>.
    /// </summary>
    /// <param name="stat">The <see cref="StatData"/> of the stat we are creating in the <see cref="StatBlock"/></param>
    /// <param name="value">The value of the stat to store</param>
    /// <returns>A <see cref="bool"/> indicating whether a <see cref="StatData"/> with data was found in the <see cref="StatBlock"/></returns>
    public bool Register(StatData stat, float value) => m_stats.TryAdd(stat, value);
    /// <summary>
    /// Unregisters a stat from the <see cref="StatBlock"/>.
    /// </summary>
    /// <param name="stat">The <see cref="StatData"/> of the value to unregister</param>
    /// <returns>A <see cref="bool"/> indicating whether the removal was successful</returns>
    public bool Unregister(StatData stat) => m_stats.Remove(stat);
    /// <summary>
    /// Attempts to get the raw value of a stat without applying any <see cref="StatModifier"/>s
    /// </summary>
    /// <param name="stat">The <see cref="StatData"/> to retrieve a value for</param>
    /// <param name="value">The resulting value of the stat</param>
    /// <returns>A <see cref="bool"/> indicating whether the <see cref="StatData"/> was found in the <see cref="StatBlock"/></returns>
    public bool TryGetRawStat(StatData stat, out float value) => m_stats.TryGetValue(stat, out value);
    /// <summary>
    /// Updates the raw value of a stat. This is the value that is modified by any applicable <see cref="StatModifier"/>s.
    /// </summary>
    /// <param name="stat">The <see cref="StatData"/> to modify the value of</param>
    /// <param name="value">The new value of the data</param>
    /// <returns>A <see cref="bool"/> indicating whether the update was successful</returns>
    public bool UpdateRawStat(StatData stat, float value)
    {
        if (!m_stats.ContainsKey(stat)) return false;
        m_stats[stat] = value;
        return true;
    }
    /// <summary>
    /// Attempts to get the value of a stat. This is the value that is modified by any applicable <see cref="StatModifier"/>s.
    /// </summary>
    /// <param name="stat">The <see cref="StatData"/> to retrieve the value for</param>
    /// <param name="value">The resulting value of the stat</param>
    /// <returns>A <see cref="bool"/> indicating whether the stat was found</returns>
    public bool TryGetModifiedStat(StatData stat, out float value)
    {
        value = 0;
        if (!m_stats.TryGetValue(stat, out float baseValue)) return false;
        StatQuery query = new(stat, baseValue);
        Broker.PerformStatQuery(this, query);
        value = query.Value;
        return true;
    }
}