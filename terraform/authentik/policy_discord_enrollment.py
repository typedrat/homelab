from authentik.core.models import Group # type: ignore
GUILD_API_URL = "https://discord.com/api/users/@me/guilds/${guildId}/member"

# Ensure flow is only run during OAuth logins via Discord
if context["source"].provider_type != "discord":
    return True # type: ignore

# Get the user-source connection object from the context, and get the access token
connection = context.get("goauthentik.io/sources/connection")
if not connection:
    return False # type: ignore
access_token = connection.access_token

guild_member_request = requests.get(
    GUILD_API_URL,
    headers={
        "Authorization": f"Bearer {access_token}",
    },
)
guild_member_info = guild_member_request.json()

# Ensure we are not being ratelimited
if guild_member_request.status_code == 429:
    ak_message(f"Discord is throttling this connection. Retry in {int(guild_member_info['retry_after'])}s")
    return False # type: ignore

# Ensure user is a member of the guild
if "code" in guild_member_info:
    if guild_member_info["code"] == 10004:
        ak_message("User is not a member of the guild '${guildName}'")
    else:
        ak_create_event("discord_error", source=context["source"], code=guild_member_info["code"])
        ak_message("Discord API error, try again later.")
    return False # type: ignore

# Get all discord_groups
discord_groups = Group.objects.filter(attributes__discord_role_id__isnull=False)

# Filter matching roles based on guild_member_info['roles']
user_groups_discord_updated = discord_groups.filter(attributes__discord_role_id__in=guild_member_info["roles"])

# Filter out groups where the user has an excluded role
for group in user_groups_discord_updated:
    excluded_role_id = group.attributes.get('discord_role_id_exclude')
    if excluded_role_id and excluded_role_id in guild_member_info["roles"]:
        user_groups_discord_updated = user_groups_discord_updated.exclude(pk=group.pk)

# Set matchin_roles in flow context
request.context["flow_plan"].context["groups"] = user_groups_discord_updated

# Create event with roles added
ak_create_event(
    "discord_role_sync",
    user_discord_roles_added=", ".join(str(group) for group in user_groups_discord_updated),
)

return True # type: ignore
