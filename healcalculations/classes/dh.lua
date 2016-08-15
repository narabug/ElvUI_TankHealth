--Code adapted from weakaura by MightBeGiant (with permission)
--http://www.mmo-champion.com/threads/1984610-Demon-Hunter-Weak-Auras-Thread?p=41713755&viewfull=1#post41713755
local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TH = E:GetModule("TankHealth");


local function GetArtifactMultiplier()
    local devourSoulsRank = TH:GetArtifactTraitRank(1233)
    local tormentedSoulsRank = TH:GetArtifactTraitRank(1328)
    -- Devour souls multiplier is 3% * rank
    local multiplier = 1 + devourSoulsRank * 0.03
    -- Tormented Souls multiplier is 10% * rank
    multiplier = multiplier * (1 + tormentedSoulsRank * 0.1)
    return multiplier
end

function TH:Calculate_DH()

    -- Stat multipliers
    local AP = UnitAttackPower("player")
    local pain = UnitPower("player")
    if pain < 30 then
        return 0
    end
    local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
    local versatilityMulti = 1 + (versatility / 100)

    -- Artifact trait multipliers
    local artifactMulti = GetArtifactMultiplier()

    -- Soul Fragments healing
    local fragments = 0
    if UnitBuff("player", "Soul Fragments") then
        fragments = select(4, UnitBuff("player", "Soul Fragments"))
    end

    local singleFragHeal = (2.5 * AP) * versatilityMulti
    local totalFragHeal = singleFragHeal * fragments

    -- Soul Cleave healing
    local cleaveHeal = ((2 * AP) * 4.5) * versatilityMulti * (min(60, pain) / 60) * artifactMulti
--    local cleaveHealMax = ((2 * AP) * 4.5) * versatilityMulti * artifactMulti

    -- Total healing
    local totalHeal = (totalFragHeal + cleaveHeal)
--    local totalHealMax = ((singleFragHeal * 5) + cleaveHealMax)

    return math.ceil(totalHeal)
end