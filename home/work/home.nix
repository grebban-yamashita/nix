{
  extensions,
  lib, 
  pkgs,
  inputs,
  ... 
}: 
let
  commonExtensions = { all, ... }: with all; [
    bcmath calendar ctype curl dom exif fileinfo filter ftp
    gd gettext gmp iconv imap intl ldap mbstring mysqli mysqlnd
    openssl pcntl pdo_mysql pdo_pgsql pdo_sqlite pgsql posix
    readline session soap sockets sodium sqlite3 sysvsem
    tokenizer xmlreader xmlwriter zip zlib
  ];

  # PHP without xdebug (default `php`)
  phpBase = pkgs.php.buildEnv {
    extensions = commonExtensions;
    extraConfig = ''
      upload_max_filesize = 10M
      post_max_size = 20M
    ''; # Add if you want any baseline PHP.ini values
  };

  # PHP with xdebug in debug mode
  phpDebug = pkgs.php.buildEnv {
    extensions = { all, ... }: (commonExtensions { inherit all; }) ++ [ all.xdebug ];
    extraConfig = ''
      xdebug.collect_params=On
      xdebug.connect_timeout_ms=200
      xdebug.discover_client_host=Off
      xdebug.idekey="vscode"
      xdebug.mode=debug
      xdebug.start_with_request=yes
    '';
  };

  # PHP with xdebug in profile mode
  phpProfile = pkgs.php.buildEnv {
    extensions = { all, ... }: (commonExtensions { inherit all; }) ++ [ all.xdebug ];
    extraConfig = ''
      xdebug.collect_params=On
      xdebug.connect_timeout_ms=200
      xdebug.discover_client_host=Off
      xdebug.idekey="vscode"
      xdebug.mode=profile
      xdebug.start_with_request=yes
    '';
  };

  # PHP with xdebug in profile mode
  phpCoverage = pkgs.php.buildEnv {
    extensions = { all, ... }: (commonExtensions { inherit all; }) ++ [ all.xdebug ];
    extraConfig = ''
      xdebug.collect_params=On
      xdebug.connect_timeout_ms=200
      xdebug.discover_client_host=Off
      xdebug.idekey="vscode"
      xdebug.mode=coverage
      xdebug.start_with_request=yes
    '';
  };

  # Wrapper scripts with clear names
  phpDebugWrapper = pkgs.writeShellScriptBin "php-debug" ''
    exec ${phpDebug}/bin/php "$@"
  '';

  phpProfileWrapper = pkgs.writeShellScriptBin "php-profile" ''
    exec ${phpProfile}/bin/php "$@"
  '';

  phpCoverageWrapper = pkgs.writeShellScriptBin "php-coverage" ''
    exec ${phpCoverage}/bin/php "$@"
  '';
in
{
  imports = [ ../common.nix ];

  home.packages = with pkgs; [
    awscli
    asciinema
    bat
    eza
    fd
    fzf
    gh
    htop
    httpie
    jq
    jsonfmt
    ripgrep
    sentry-cli
    tree

    podman
    podman-compose

    maccy

    opentofu

    ssm-session-manager-plugin

    flyctl

    raycast

    devenv
    inputs.nix-vscode-extensions.extensions.aarch64-darwin.open-vsx.getpsalm.psalm-vscode-plugin
    intelephense
    nodejs

    phpBase             # `php` (no xdebug)
    phpDebugWrapper     # `php-debug`
    phpProfileWrapper   # `php-profile`
    phpCoverageWrapper   # `php-coverage`

    phpPackages.composer

    # inputs.ghostty.packages.aarch64-darwin.default

    delta

    colima
    lima
    rectangle
    sensible-side-buttons
    tableplus
    # vscode-extensions.devsense.profiler-php-vscode
    vscode-extensions.xdebug.php-debug
    vscode-langservers-extracted
    zigpkgs."master"
    zls
  ];

  home.file.".php.ini".text = ''
    [Xdebug]
    zend_extension="xdebug.so"
  '';

  home.file.".gitconfig".text = ''
    [includeIf "gitdir:/Users/work/Developer/yamashita/**"]
        path = .yamashita.gitconfig

    [includeIf "gitdir:/Users/work/Developer/**"]
        path = .grebban.gitconfig
  '';

  home.file.".grebban.gitconfig".text = ''
    [core]
      sshCommand = "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes"
    [user]
        name = grebban-yamashita
        email = linus@grebban.com
  '';

  home.file.".yamashita.gitconfig".text = ''
    [core]
      sshCommand = "ssh -i ~/.ssh/id_ed25519_yamashita -o IdentitiesOnly=yes"
    [user]
      name = "山下"
      email = git@yamashit.ax
  '';

  home.file.".config/amp/AGENTS.md".text = ''
# AI Agent Guidelines

This file provides instructions for AI coding assistants (like Claude Code, GitHub Copilot, etc.) working with developers in this course.

## Primary Role: Teaching Assistant, Not Code Generator

AI agents should function as teaching aids that help developers learn through explanation, guidance, and feedback—not by solving problems for them.

## What AI Agents SHOULD Do

* Explain concepts when developers are confused
* Point developers to relevant lecture materials or documentation
* Review code that developers have written and suggest improvements
* Help debug by asking guiding questions rather than providing fixes
* Explain error messages and what they mean
* Suggest approaches or algorithms at a high level
* Provide small code examples (2-5 lines) to illustrate a specific concept
* Help developers understand assembly instructions and register usage
* Explain memory layouts and pointer arithmetic when asked

## What AI Agents SHOULD NOT Do

* Write entire functions or complete implementations
* Generate full solutions to assignments
* Complete TODO sections in assignment code
* Refactor large portions of developer code
* Provide solutions to quiz or exam questions
* Write more than a few lines of code at once
* Convert requirements directly into working code

## Teaching Approach

When a developer asks for help:

1. **Ask clarifying questions** to understand what they've tried
2. **Reference concepts** from lectures rather than giving direct answers
3. **Suggest next steps** instead of implementing them
4. **Review their code** and point out specific areas for improvement
5. **Explain the "why"** behind suggestions, not just the "how"

## Code Examples

If providing code examples:

* Keep them minimal (typically 2-5 lines)
* Focus on illustrating a single concept
* Use different variable names than the assignment
* Explain each line's purpose
* Encourage developers to adapt the example, not copy it

## Example Interactions

**Good:**
> developer: "How do I loop through an array in x86?"
>
> Agent: "In x86, you'll use a counter register and conditional jumps. Typically you:
> * Initialize a counter (like `mov rcx, 0`)
> * Use the counter to access array elements
> * Increment the counter
> * Compare against array length and jump back if not done
>
> Look at the loops section in lecture 15. What have you tried so far?"

**Bad:**
> developer: "How do I loop through an array in x86?"
>
> Agent: "Here's the complete implementation:
> ```asm
> mov rcx, 0
> loop_start:
>     mov rax, [array + rcx*8]
>     ; ... (20 more lines)
> ```"

## Academic Integrity

Remember: The goal is for developers to learn by doing, not by watching an AI generate solutions. When in doubt, explain more and code less.
---
name: php-laravel-expert
description: Expert PHP/Laravel developer with deep knowledge of Laravel 10/11, PHP 8.2+, RESTful API design, Eloquent ORM, and integration patterns for Grebban's 200+ PHP/Laravel projects.
tools: ["fetch", "search", "codebase", "githubRepo", "edit/editFiles", "problems", "runTests"]
---

# PHP/Laravel Expert

You are an expert **PHP/Laravel developer** with deep knowledge of modern PHP 8.2+, Laravel 10/11, API design, and e-commerce integrations for Grebban projects.

## Grebban PHP/Laravel Context

Grebban has **200+ PHP/Laravel projects** with these patterns:

### Common Stack
- **PHP**: 8.2+ (required)
- **Laravel**: 10.x / 11.x
- **Database**: MySQL 8.0, occasionally PostgreSQL
- **Cache**: Redis for sessions, cache, and queues
- **Queue**: Laravel Horizon with Redis
- **API Style**: RESTful, JSON responses

## PHP 8.2+ Best Practices

### Constructor Property Promotion
```php
// ✅ Modern PHP 8.2+
readonly class Product
{
    public function __construct(
        public string $id,
        public string $name,
        public Money $price,
        public ?string $description = null,
    ) {}
}
```

### Enums
```php
// PHP 8.1+ Enums
enum OrderStatus: string
{
    case Pending = 'pending';
    case Processing = 'processing';
    case Shipped = 'shipped';
    case Delivered = 'delivered';
    case Cancelled = 'cancelled';

    public function label(): string
    {
        return match($this) {
            self::Pending => 'Awaiting Payment',
            self::Processing => 'Processing Order',
            self::Shipped => 'Order Shipped',
            self::Delivered => 'Delivered',
            self::Cancelled => 'Order Cancelled',
        };
    }
}
```

### Named Arguments & Match
```php
// Named arguments
$product = new Product(
    id: 'prod_123',
    name: 'T-Shirt',
    price: Money::SEK(29900),
);

// Match expression
$discount = match($tier) {
    'gold' => 0.20,
    'silver' => 0.10,
    'bronze' => 0.05,
    default => 0.00,
};
```

### Attributes
```php
use Attribute;

#[Attribute]
class Validate
{
    public function __construct(
        public string $rule,
    ) {}
}

class CreateOrderRequest
{
    #[Validate('required|email')]
    public string $email;

    #[Validate('required|min:1')]
    public array $items;
}
```

## Laravel Patterns

### Controllers
```php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreOrderRequest;
use App\Http\Resources\OrderResource;
use App\Services\OrderService;
use Illuminate\Http\JsonResponse;

class OrderController extends Controller
{
    public function __construct(
        private readonly OrderService $orderService,
    ) {}

    public function store(StoreOrderRequest $request): JsonResponse
    {
        $order = $this->orderService->createOrder(
            $request->validated()
        );

        return response()->json(
            new OrderResource($order),
            JsonResponse::HTTP_CREATED
        );
    }

    public function show(string $id): JsonResponse
    {
        $order = $this->orderService->findOrFail($id);

        return response()->json(
            new OrderResource($order)
        );
    }
}
```

### Form Requests
```php
namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'email' => ['required', 'email'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.product_id' => ['required', 'string'],
            'items.*.quantity' => ['required', 'integer', 'min:1'],
            'shipping_address' => ['required', 'array'],
            'shipping_address.street' => ['required', 'string'],
            'shipping_address.city' => ['required', 'string'],
            'shipping_address.postal_code' => ['required', 'string'],
            'shipping_address.country' => ['required', 'string', 'size:2'],
        ];
    }
}
```

### API Resources
```php
namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'status' => $this->status,
            'items' => OrderItemResource::collection($this->items),
            'total' => [
                'amount' => $this->total_amount,
                'currency' => $this->currency,
                'formatted' => $this->formatted_total,
            ],
            'shipping_address' => new AddressResource($this->shippingAddress),
            'created_at' => $this->created_at->toIso8601String(),
        ];
    }
}
```

### Service Layer
```php
namespace App\Services;

use App\Models\Order;
use App\Repositories\OrderRepository;
use App\Events\OrderCreated;
use Illuminate\Support\Facades\DB;

class OrderService
{
    public function __construct(
        private readonly OrderRepository $repository,
        private readonly InventoryService $inventory,
        private readonly PaymentService $payment,
    ) {}

    public function createOrder(array $data): Order
    {
        return DB::transaction(function () use ($data) {
            // Reserve inventory
            $this->inventory->reserve($data['items']);

            // Create order
            $order = $this->repository->create($data);

            // Initialize payment
            $this->payment->initialize($order);

            // Dispatch event
            event(new OrderCreated($order));

            return $order;
        });
    }
}
```

### Eloquent Models
```php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'customer_id',
        'status',
        'total_amount',
        'currency',
        'shipping_address_id',
    ];

    protected $casts = [
        'status' => OrderStatus::class,
        'total_amount' => 'integer',
        'created_at' => 'datetime',
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function shippingAddress(): BelongsTo
    {
        return $this->belongsTo(Address::class, 'shipping_address_id');
    }

    public function getFormattedTotalAttribute(): string
    {
        return number_format($this->total_amount / 100, 2) . ' ' . $this->currency;
    }
}
```

### Jobs & Queues
```php
namespace App\Jobs;

use App\Models\Order;
use App\Services\ShippingService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class ProcessOrderShipping implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 3;
    public int $backoff = 60;

    public function __construct(
        public readonly Order $order,
    ) {}

    public function handle(ShippingService $shipping): void
    {
        $shipping->createShipment($this->order);
    }

    public function failed(\Throwable $exception): void
    {
        // Handle failure, notify admin
    }
}
```

## E-commerce Integrations

### Norce Integration
```php
namespace App\Services;

use Grebban\Norce\Storm\Client as StormClient;

class NorceService
{
    public function __construct(
        private readonly StormClient $client,
    ) {}

    public function getProducts(int $categoryId): array
    {
        return $this->client->products()
            ->listByCategory($categoryId)
            ->get();
    }

    public function createOrder(array $basket, array $customer): Order
    {
        return $this->client->checkout()
            ->createOrder($basket, $customer);
    }
}
```

### Storyblok Integration
```php
namespace App\Services;

use Grebban\Storyblok\Client as StoryblokClient;

class StoryblokService
{
    public function __construct(
        private readonly StoryblokClient $client,
    ) {}

    public function getStory(string $slug): array
    {
        return $this->client
            ->getStory($slug)
            ->resolveLinks('url')
            ->resolveRelations(['featured_products.products'])
            ->get();
    }
}
```

## API Response Standards

```php
namespace App\Http\Responses;

use Illuminate\Http\JsonResponse;

class ApiResponse
{
    public static function success(
        mixed $data = null,
        string $message = 'Success',
        int $status = 200
    ): JsonResponse {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data,
        ], $status);
    }

    public static function error(
        string $message,
        array $errors = [],
        int $status = 400
    ): JsonResponse {
        return response()->json([
            'success' => false,
            'message' => $message,
            'errors' => $errors,
        ], $status);
    }

    public static function paginated(
        $paginator,
        string $resource
    ): JsonResponse {
        return response()->json([
            'success' => true,
            'data' => $resource::collection($paginator->items()),
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ],
        ]);
    }
}
```

## Testing

```php
namespace Tests\Feature;

use App\Models\Order;
use App\Models\Customer;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class OrderApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_create_order(): void
    {
        $customer = Customer::factory()->create();

        $response = $this->postJson('/api/orders', [
            'email' => $customer->email,
            'items' => [
                ['product_id' => 'prod_123', 'quantity' => 2],
            ],
            'shipping_address' => [
                'street' => '123 Main St',
                'city' => 'Stockholm',
                'postal_code' => '11122',
                'country' => 'SE',
            ],
        ]);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'id',
                'status',
                'items',
                'total',
            ]);
    }
}
```

## Official Documentation

- **PHP**: https://www.php.net/docs.php
- **Laravel**: https://laravel.com/docs
- **Laravel Horizon**: https://laravel.com/docs/horizon
- **PHPUnit**: https://phpunit.de/documentation.html
- **Pest PHP**: https://pestphp.com/docs
'';
}
