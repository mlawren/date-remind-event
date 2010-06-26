use strict;
use warnings;
use Test::More;

eval q{use Test::Spelling};
plan skip_all => 'Test::Spelling is required for this test' if $@;

my @stopwords;
for (<DATA>) {
    chomp;
    push @stopwords, $_
        unless /\A (?: \# | \s* \z)/msx;    # skip comments, whitespace
}

add_stopwords(@stopwords);
set_spell_cmd('aspell list -l en');
all_pod_files_spelling_ok();

__DATA__
## personal names
Aankhen
Aran
autarch
chansen
chromatic's
Debolaz
Deltac
dexter
doy
ewilhelm
frodwith
Goulah
gphat
groditi
Hardison
jrockway
Kinyon's
Kogman
kolibrie
konobi
Lanyon
lbr
Luehrs
McWhirter
merlyn
mst
nothingmuch
Pearcey
perigrin
phaylon
Prather
Ragwitz
Reis
rafl
rindolf
rlb
Rockway
Roditi
Rolsky
Roszatycki
Roszatycki's
sartak
Sedlacek
Shlomi
SL
stevan
Stevan
SIGNES
tozt
Vilain
wreis
Yuval
Goro
gfx
Yappo
tokuhirom
wu

## proper names
AOP
CLOS
cpan
CPAN
OCaml
ohloh
SVN
CGI
FastCGI
DateTime

## Moose
AttributeHelpers
BankAccount
BankAccount's
BinaryTree
BUILDALL
BUILDARGS
CheckingAccount
ClassName
ClassNames
LocalName
RemoteName
MethodName
OwnerClass
AttributeName

clearers
composable
Debuggable
DEMOLISHALL
hardcode
immutabilization
immutabilize
introspectable
metaclass
Metaclass
METACLASS
metaclass's
metadata
MetaObject
metaprogrammer
metarole
metatraits
mixins
MooseX
MouseX
Num
OtherName
oose
ouse
PosInt
PositiveInt
ro
rw
RoleSummation
Str
TypeContraints


## computerese
API
APIs
arity
Baz
canonicalizes
canonicalized
Changelog
codebase
committer
committers
compat
datetimes
dec
definedness
deinitialization
destructor
destructors
destructuring
dev
DWIM
DUCKTYPE
GitHub
hashrefs
hotspots
immutabilize
immutabilized
inline
inlines
invocant
invocant's
irc
IRC
isa
JSON
kv
login
mul
namespace
namespaced
namespaces
namespacing
transformability
redispatch

# as in required-ness
ness
O'Caml
OO
OOP
ORM
overridable
parameterizable
parameterization
parameterize
parameterized
parameterizes
params
pluggable
prechecking
prepends
pu
rebase
rebased
rebasing
reblesses
refactored
refactoring
rethrows
runtime
serializer
stacktrace
startup
subclassable
subname
subtyping
TODO
unblessed
unexport
UNIMPORTING
Unported
unsets
unsettable
utils
whitelist
Whitelist
workflow

## other jargon
bey
gey

## neologisms
breakability
delegatee
featureful
hackery
hacktern
wrappee

## compound
# half-assed
assed
# role-ish, Ruby-ish, medium-to-large-ish
ish
# kool-aid
kool
# pre-5.10
pre
# vice versa
versa
lookup
# co-maint
maint

## slang
C'mon
might've
Nuff
steenkin

## things that should be in the dictionary, but are not
attribute's
declaratively
everybody's
everyone's
human's
indices
initializers
newfound
reimplements
reinitializes
specializer

## misspelt on purpose
emali
uniq

