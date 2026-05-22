public interface ISpawner<in T>
{
    void Spawn(T prefab);
}