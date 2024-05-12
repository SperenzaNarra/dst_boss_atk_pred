#include "steam_api.h"

#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <netinet/ip.h>
#include <unistd.h>

static bool connected = false;

class dummyclass {
public:
    void oncomplete(SubmitItemUpdateResult_t* result, bool bIOFailure)
    {
        if (result->m_eResult == k_EResultOK) {
            printf("Update completed\n");
            exit(0);
        } else {
            printf("Update failed, code: %d\n", result->m_eResult);
            exit(1);
        }
    }
    CCallResult<dummyclass, SubmitItemUpdateResult_t> cb;
};

int main(int argc, const char *argv[])
{
    if (argc < 4) {
        fprintf(stderr, "Usage: %s [workshop_id] [directory] [changelog] [[tags] ...]\n", argv[0]);
        exit(1);
    }

    uint64_t workshop_id = atoll(argv[1]);
    const char *directory = argv[2];
    const char *changelog = argv[3];
    const char **tags = &argv[4];

    dummyclass dummy;

    if (!SteamAPI_Init()) {
        fprintf(stderr, "Could not init Steam API\n");
        exit(1);
    }

    printf("User ID: %llu\n", SteamUser()->GetSteamID().ConvertToUint64());

    UGCUpdateHandle_t handle = SteamUGC()->StartItemUpdate(322330, workshop_id);
    SteamParamStringArray_t steamtags = { tags, argc - 4 };
    SteamUGC()->SetItemTags(handle, &steamtags);
    SteamUGC()->SetItemContent(handle, directory);

    const SteamAPICall_t call = SteamUGC()->SubmitItemUpdate(handle, changelog);
    dummy.cb.Set(call, &dummy, &dummyclass::oncomplete);

    setvbuf(stdout, NULL, _IONBF, 0);
    printf("Starting Upload...\n");

    uint64 last_processed = -1ULL;
    for (int i = 0;; i++) {
        uint64 processed, total, percentage;

        SteamAPI_RunCallbacks();
        SteamUGC()->GetItemUpdateProgress(handle, &processed, &total);

        if (total)
            percentage = processed * 100 / total;
        else
            percentage = 0;

        if (processed != last_processed || i >= 20) {
            printf("Progress: %lld/%lld (%lld%%)\n", processed, total, percentage);
            last_processed = processed;
            i = 0;
        }
        usleep(50000);
    }
}
