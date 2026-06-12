using UnityEngine;
using UnityEngine.Splines;

public class UnderbellyFollow : MonoBehaviour
{
    [SerializeField] private float _speed = 5.0f;
    [SerializeField] private GameObject _playerSteamBoat;
    private Rigidbody _rigidbody;
    private SplineContainer _spline;
    private float _underBellyProgress;
    void Start()
    {
        _spline = FindAnyObjectByType<SplineContainer>();
        _rigidbody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        _underBellyProgress += _speed / _spline.CalculateLength() * Time.deltaTime;
        transform.position = _spline.EvaluatePosition(_underBellyProgress);
        _rigidbody.MovePosition(transform.position);
    }
}
