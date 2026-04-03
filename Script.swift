using UnityEngine;

public class MobileAimUltimatePro : MonoBehaviour
{
    public float referenceFPS = 120f;
    public float maxFPS = 120f;

    public float deadZone = 0.015f;

    public float baseSensitivity = 7.5f;
    public float boost = 28f;
    public float maxSensitivity = 500f;

    public AnimationCurve curve = new AnimationCurve(
        new Keyframe(0f, 0f),
        new Keyframe(0.05f, 0.4f),
        new Keyframe(0.15f, 2.5f),
        new Keyframe(0.3f, 7.5f),
        new Keyframe(1f, 15f)
    );

    public float horizontalLock = 0.5f;

    public float dampingLow = 0.9998f;
    public float dampingHigh = 0.92f;
    public float friction = 0.05f;

    public float maxStep = 5f;

    public float minPitch = -70f;
    public float maxPitch = 70f;

    public float headZonePercent = 0.88f;
    public float headSnapStrength = 0.92f;
    public float headHold = 0.08f;

    public float assistRadius = 2.5f;
    public float assistStrength = 6f;
    public Transform target;

    public float recoilX = 0.6f;
    public float recoilY = 1.2f;
    public float recoilRecover = 6f;

    Vector2 filtered;
    Vector2 velocity;
    Vector2 recoil;
    float pitch;
    float fpsScale = 1f;

    public float sensUI = 1f;

    void UpdateFPS()
    {
        float fps = Mathf.Clamp(1f / Mathf.Max(Time.unscaledDeltaTime, 0.0001f), referenceFPS, maxFPS);
        fpsScale = fps / referenceFPS;
    }

    void Update()
    {
        sensUI = Mathf.Clamp(sensUI, 0.2f, 3f);
    }

    public void Aim(Vector2 joy, bool firing)
    {
        UpdateFPS();

        if (Mathf.Abs(joy.x) < deadZone) joy.x = 0f;
        if (Mathf.Abs(joy.y) < deadZone) joy.y = 0f;

        float mag = joy.magnitude;
        Vector2 dir = mag > 0f ? joy.normalized : Vector2.zero;

        float c = curve.Evaluate(mag);
        float sens = Mathf.Min((baseSensitivity + c * boost) * sensUI, maxSensitivity);

        Vector2 input = dir * c * sens * Time.deltaTime * fpsScale;

        input.y *= Mathf.Lerp(3.5f, 5.5f, mag);
        input.x *= horizontalLock;

        if (Mathf.Abs(input.y) < 0.1f) input.y = 0f;

        if (target != null)
        {
            Vector3 dirToTarget = (target.position - transform.position).normalized;
            Vector3 localDir = transform.InverseTransformDirection(dirToTarget);

            float dist = Vector3.Angle(transform.forward, dirToTarget);

            if (dist < assistRadius)
            {
                Vector2 assist = new Vector2(localDir.x, localDir.y) * assistStrength * Time.deltaTime;
                input += assist;
            }
        }

        filtered = Vector2.Lerp(filtered, input, 50f * Time.deltaTime);

        velocity = filtered;
        velocity *= (1f - friction);
        velocity *= Mathf.Lerp(dampingLow, dampingHigh, mag);
        velocity = Vector2.ClampMagnitude(velocity, maxStep);

        if (firing)
        {
            recoil.x += Random.Range(-recoilX, recoilX) * Time.deltaTime;
            recoil.y += recoilY * Time.deltaTime;
        }
        else
        {
            recoil = Vector2.Lerp(recoil, Vector2.zero, recoilRecover * Time.deltaTime);
        }

        velocity -= recoil;

        float headZone = maxPitch * headZonePercent;

        if (pitch >= headZone && velocity.y > 0f)
        {
            velocity.y = Mathf.Lerp(velocity.y, 0.02f, headSnapStrength);
        }

        if (pitch >= headZone && Mathf.Abs(joy.y) < deadZone)
        {
            pitch = Mathf.Lerp(pitch, headZone, headHold);
            velocity.y = 0f;
        }

        pitch -= velocity.y;
        pitch = Mathf.Clamp(pitch, minPitch, maxPitch);

        transform.localRotation = Quaternion.Euler(pitch, 0f, 0f);

        if (transform.parent != null)
            transform.parent.Rotate(Vector3.up * velocity.x);
        else
            transform.Rotate(Vector3.up * velocity.x, Space.World);
    }
}