/// <summary>
/// Represents a query for a specific stat from a <see cref="StatBroker"/>
/// </summary>
public class StatQuery
{
    /// <summary>
    /// The stat we are querying for
    /// </summary>
    public readonly StatData Data;
    /// <summary>
    /// The result of the query
    /// </summary>
    public float Value;
    public StatQuery(StatData data, float value)
    {
        Data = data;
        Value = value;
    }
}