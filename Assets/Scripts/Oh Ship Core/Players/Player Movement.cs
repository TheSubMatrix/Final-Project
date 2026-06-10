using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;

/// <summary>
/// Handle player movement through taking input from via <see cref="IPlayerControllable"/> from any <see cref="IPlayerController"/>
/// </summary>
public class PlayerMovement : MonoBehaviour
{
    [SerializeField, Range(0f, 90f)] float maxGroundAngle = 25f;
    float minGroundDotProduct;
    int stepsSinceLastGrounded;
    bool onGround => groundContactCount > 0;

    Rigidbody connectedBody, pastConnectedBody;
    int groundContactCount;

    float pastPlatformYaw, platformYaw;

    Vector3 contactNormal, connectionWorldPos, connectionLocalPos;
    Vector3 velocity, connectionVelocity;

    Rigidbody m_rigidbody;
    Vector2 m_desiredMovement;
    [SerializeField] float m_acceleration;
    [SerializeField] float m_deceleration;
    [SerializeField] float m_moveSpeed;
    [FormerlySerializedAs("cameraTurn")] [SerializeField] Transform m_camera;
    [FormerlySerializedAs("lookSens")] [SerializeField] float m_lookSensitivity = 30f;
    float m_lookPitch;
    Quaternion m_lookYaw = Quaternion.identity;
    Vector2 m_currentLookInput;
    IPlayerController m_playerController;
    public void OnMovementInputChanged(Vector2 input) => m_desiredMovement = Vector2.ClampMagnitude(input, 1) * m_moveSpeed;
    public void OnLookInputChanged(Vector2 input) => m_currentLookInput = input;
    void Start()
    {
        m_rigidbody = GetComponent<Rigidbody>();
    }

    void Awake()
    {
        OnValidate();
    }
    private void OnValidate()
    {
        minGroundDotProduct = Mathf.Cos(maxGroundAngle * Mathf.Deg2Rad);
    }

    void FixedUpdate()
    {
        UpdateState();
        AdjustVelocityAndRotation();


        ClearState();
    }

    void LateUpdate()
    {
        m_lookYaw *= Quaternion.Euler(0, m_currentLookInput.x * m_lookSensitivity * Time.deltaTime, 0);
        m_lookPitch = Mathf.Clamp(m_lookPitch - m_currentLookInput.y * m_lookSensitivity * Time.deltaTime, -90, 90);
        m_camera.rotation = m_lookYaw * Quaternion.Euler(m_lookPitch, 0, 0);
    }
    float GetRate(float current, float desired) => Mathf.Abs(current) < Mathf.Abs(desired) || !Mathf.Approximately(Mathf.Sign(current), Mathf.Sign(desired)) ? m_acceleration : m_deceleration;

    void Update()
    {

    }


    void OnCollisionEnter(Collision collision)
    {
        EvaluateCollision(collision);
    }

    void OnCollisionStay(Collision collision)
    {
        EvaluateCollision(collision);
    }

    void EvaluateCollision(Collision collision)
    {
        for (int i = 0; i < collision.contactCount; i++)
        {
            Vector3 normal = collision.GetContact(i).normal;

            if (normal.y >= minGroundDotProduct)
            {
                groundContactCount++;
                contactNormal += normal;
                if (!connectedBody)
                {
                    connectedBody = collision.rigidbody;
                }
            }
        }

        if (groundContactCount > 0)
        {
            contactNormal.Normalize();
        }
    }

    void ClearState()
    {
        groundContactCount = 0;
        pastConnectedBody = connectedBody;
        connectedBody = null;
        connectionVelocity = Vector3.zero;
    }

    void UpdateState()
    {
        stepsSinceLastGrounded += 1;
        if(onGround || SnapToGround())
        {
            stepsSinceLastGrounded = 0;
        }

        if (groundContactCount > 1)
        {
            contactNormal.Normalize();
        }
        else
        {
            contactNormal = Vector3.up;
        }
        velocity = m_rigidbody.linearVelocity;
        if (connectedBody)
        {
            if (connectedBody.isKinematic || connectedBody.mass >= m_rigidbody.mass)
            {
                UpdateConnectionState();
            }
        }
    }

    void UpdateConnectionState()
    {
        if (connectedBody == pastConnectedBody)
        {
            Vector3 currentWorldPos = connectedBody.transform.TransformPoint(connectionLocalPos);
            Vector3 connectionMovement = currentWorldPos - connectionWorldPos;
            connectionVelocity = connectionMovement / Time.fixedDeltaTime;

            platformYaw = connectedBody.transform.eulerAngles.y;

            float yawDelta = Mathf.DeltaAngle(pastPlatformYaw, platformYaw);
            m_lookYaw = Quaternion.Euler(0f, yawDelta, 0f) * m_lookYaw;
        }
        connectionWorldPos = m_rigidbody.position;
        connectionLocalPos = connectedBody.transform.InverseTransformPoint(connectionWorldPos);
        pastPlatformYaw = platformYaw;
    }

    void AdjustVelocityAndRotation()
    {

        if (onGround)
        {
            velocity = Vector3.ProjectOnPlane(m_rigidbody.linearVelocity, contactNormal);
            m_rigidbody.linearVelocity = velocity;
        }

        if (connectedBody)
        {
            Vector3 xAxis = ProjectOnContactPlane(m_lookYaw * Vector3.right).normalized;
            Vector3 zAxis = ProjectOnContactPlane(m_lookYaw * Vector3.forward).normalized;

            float connectionVelocityX = Vector3.Dot(m_lookYaw * Vector3.forward, connectionVelocity);
            float connectionVelocityZ = Vector3.Dot(m_lookYaw * Vector3.right, connectionVelocity);
            float currentX = Vector3.Dot(velocity - connectionVelocity, xAxis);
            float currentZ = Vector3.Dot(velocity - connectionVelocity, zAxis);


            float yawDelta = Mathf.DeltaAngle(pastPlatformYaw, platformYaw);
            Quaternion platformRotation = Quaternion.Euler(0f, yawDelta, 0f);

            Vector3 offset = m_rigidbody.position - connectedBody.position;
            Vector3 rotatedOffset = platformRotation * offset;
            Vector3 rotationVelocity = (rotatedOffset - offset) / Time.fixedDeltaTime;

            float rotationVelocityX = Vector3.Dot(m_lookYaw * Vector3.forward, rotationVelocity);
            float rotationVelocityZ = Vector3.Dot(m_lookYaw * Vector3.right, rotationVelocity);


            float forwardVelocity = currentX - connectionVelocityX;
            float sidewaysVelocity = currentZ - connectionVelocityZ;
            float newForward = Mathf.MoveTowards(forwardVelocity, m_desiredMovement.y, GetRate(forwardVelocity, m_desiredMovement.y)) + connectionVelocityX;
            float newSideways = Mathf.MoveTowards(sidewaysVelocity, m_desiredMovement.x, GetRate(sidewaysVelocity, m_desiredMovement.x)) + connectionVelocityZ;


            Vector3 worldVelocity = m_lookYaw * new Vector3(newSideways, 0, newForward);
            m_rigidbody.linearVelocity = new(worldVelocity.x, m_rigidbody.linearVelocity.y, worldVelocity.z);

            if (onGround)
            {
                m_rigidbody.linearVelocity = Vector3.ProjectOnPlane(m_rigidbody.linearVelocity, contactNormal);
            }
        }

    }


    Vector3 ProjectOnContactPlane(Vector3 vector)
    {
        return vector - contactNormal * Vector3.Dot(vector, contactNormal);
    }

    bool SnapToGround()//determines whether player should be clipped to the ground
    {
        if (stepsSinceLastGrounded > 1)
        {
            return false;
        }
        if (!Physics.Raycast(m_rigidbody.position, Vector3.down, out RaycastHit hit, 1.5f))
        {
            return false;
        }
        if (hit.normal.y < minGroundDotProduct)
        {
            return false;
        }

        
        groundContactCount = 1;
        contactNormal = hit.normal;
        float dot = Vector3.Dot(m_rigidbody.linearVelocity, hit.normal);
        if (dot < 0f)
        {
            Vector3 correction = hit.normal * dot;
            m_rigidbody.linearVelocity -= correction;
        }
        return true;
        
    }

}
